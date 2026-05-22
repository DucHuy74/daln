from collections import Counter
from typing import Any, Optional, Tuple

from fastapi import Body


def sorted_term_pair(a: Any, b: Any) -> Tuple[str, str]:
    """Key (term1, term2) đã sort; tránh lỗi khi Neo4j/parser trả về None."""
    sa = str(a or "").strip().lower()
    sb = str(b or "").strip().lower()
    return tuple(sorted((sa, sb)))


def find_subject(doc) -> Optional[str]:
    for token in doc:
        #prep = giới từ
        if token.lower_ == "as" and token.dep_ == "prep":
            for child in token.children:
                if child.dep_ == "pobj":
                    return child.lemma_
                
        if token.i > 5 and token.dep_ not in ("nsubj", "nsubjpass", "ROOT"):
            break
    return None


_WANT_LIKE_LEMMAS = frozenset({
    "want", "need", "wish", "hope", "prefer", "like", "love", "expect",
    "try", "attempt", "plan", "request", "require", "order", "choose",
})
_SKIP_VERB_LEMMAS = frozenset({"be", "get", "become", "able"})


def _deepest_content_verb(root_verb):
    """Lấy động từ nội dung sâu nhất trong subtree (want to be able to manage -> manage)."""
    candidates = [
        t for t in root_verb.subtree
        if t.pos_ == "VERB" and t.lemma_ not in _SKIP_VERB_LEMMAS
    ]
    if not candidates:
        return root_verb
    return max(candidates, key=lambda t: t.i)


def _find_verb_after_to(main_verb):
    """Fallback: quét token sau 'want/need/...' + 'to' để lấy VERB (spaCy đôi khi không gắn xcomp)."""
    tokens = list(main_verb.doc)
    start = main_verb.i
    for i in range(start, len(tokens)):
        if tokens[i].lemma_ not in _WANT_LIKE_LEMMAS:
            continue
        for j in range(i + 1, min(i + 8, len(tokens))):
            if tokens[j].lemma_ != "to":
                continue
            for k in range(j + 1, min(j + 6, len(tokens))):
                if tokens[k].pos_ == "VERB" and tokens[k].lemma_ not in _SKIP_VERB_LEMMAS:
                    return tokens[k]
    return None


def _resolve_action_verb(main_verb):
    """User story: 'I want to <verb> ...' -> action là <verb>, không phải want."""
    if main_verb.lemma_ not in _WANT_LIKE_LEMMAS:
        return main_verb

    for child in main_verb.children:
        if child.dep_ == "xcomp" and child.pos_ == "VERB":
            return _deepest_content_verb(child)

    for child in main_verb.children:
        if child.dep_ in ("ccomp", "advcl", "relcl") and child.pos_ == "VERB":
            return _deepest_content_verb(child)

    after_to = _find_verb_after_to(main_verb)
    if after_to:
        return after_to

    return main_verb


def find_verb_object(doc) -> Tuple[Optional[str], Optional[str]]:
    verb = None
    obj = None

    main_verb = None
    for token in doc:
        if token.dep_ == "ROOT" and token.pos_ == "VERB":
            main_verb = token
            break

    if not main_verb:
        return None, None

    verb_token = _resolve_action_verb(main_verb)
    verb = verb_token.lemma_


    for child in verb_token.children:
        #dobj là tân ngữ trực tiếp
        #attr là thuộc tính
        #pobj là tân ngữ giới từ
        
        # direct object
        if child.dep_ in ("dobj", "obj", "attr"):
            obj = child.lemma_
            break
        
        # preposition object
        if child.dep_ == "prep":
            for prep_child in child.children:
                if prep_child.dep_ == "pobj":
                    obj = prep_child.lemma_
                    break
                
        if obj:
            break
    
    return verb, obj


def objects_frequency(svo):

    # phân tích tần xuất của object
    objects = [item['object'] for item in svo]

    object_counts = Counter(objects)

    total_objects = sum(object_counts.values())

    return {obj: round((count / total_objects) * 100, 2) 
                                for obj, count in object_counts.items()}


def print_similarity_results(title, results):
    print("\n" + "=" * 50)
    print(f"KẾT QUẢ ĐÁNH GIÁ {title} Sim353")
    print(f"   Tổng số cặp từ: {results['Sim353']['Total_Pairs']}")
    print("-" * 50)
    print(f"   Hệ số Tương quan Pearson (r): {results['Sim353']['Pearson_r']:.4f}")
    print(f"   Hệ số Tương quan Spearman (p): {results['Sim353']['Spearman_rho']:.4f}")

    print(f"KẾT QUẢ ĐÁNH GIÁ {title} Rg65")
    print(f"   Tổng số cặp từ: {results['RG65']['Total_Pairs']}")
    print("-" * 50)
    print(f"   Hệ số Tương quan Pearson (r): {results['RG65']['Pearson_r']:.4f}")
    print(f"   Hệ số Tương quan Spearman (p): {results['RG65']['Spearman_rho']:.4f}")


def route_handler(controller):
    async def handler(data: dict = Body(...)):
        return controller(data)
    return handler
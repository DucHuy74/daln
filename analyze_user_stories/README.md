def \_generate_association_rules(self, concepts: List[Dict]):

        # Gom theo user_story_id → mỗi story là 1 transaction
        # VD: User story: As an admin, I want to manage users =>["admin", "manage", "users"]
        transaction_map = {}

        for c in concepts:
            usid = c.get("db_id") or c.get("id")

            if usid not in transaction_map:
                transaction_map[usid] = []

            if c.get("role"):
                transaction_map[usid].append(c["role"])
            if c.get("action"):
                transaction_map[usid].append(c["action"])
            if c.get("object"):
                transaction_map[usid].append(c["object"])

        transactions = list(transaction_map.values())

        if not transactions:
            return transactions, []

        # Encode transactions
        te = TransactionEncoder()
        te_ary = te.fit(transactions).transform(transactions)
        df = pd.DataFrame(te_ary, columns=te.columns_)

        # Frequent itemsets
        # Tim nhom item xh chung vs tan suat >=1%
        frequent_itemsets = apriori(df, min_support=0.01, use_colnames=True)

        # Association rules
        rules_df = association_rules(frequent_itemsets, metric="confidence", min_threshold=0.1)

        rules_output = []
        for _, row in rules_df.iterrows():
            rules_output.append({
                #Dieu kien
                "antecedents": list(row["antecedents"]), # item xh trc trong rule, vd {manage} -> {admin} ->antecedents: manage
                #Ketqua
                "consequents": list(row["consequents"]), # item xh sau trong rule, vd {manage} -> {admin} ->consequents: admin
                "support": float(row["support"]), # tỷ lệ transaction có chứa cả antecedents + consequents.
                "confidence": float(row["confidence"]), #nếu antecedents xuất hiện, xác suất consequents cũng xuất hiện
                "lift": float(row["lift"])
                # do manh cua rule. >1: co y nghia, = 1-> ko co y nghia, <1 -> antecedents can tro consequents
            })

        return transactions, rules_output

- How to run project fast api:

```bash
    uvicorn app.main:app --reload
```

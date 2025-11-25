		WordSim353-cs: Evaluation Dataset for Lexical Similarity and Relatedness, based on WordSim353
		
Version 1.0						 June 1st, 2016
Authors: Silvie Cinková, Jana Straková, Jakub Hajič, Jan Hajič, Jan Hajič jr., Jolana Janoušková, Milan Straka, Miroslava Urešová.
Institute of Formal and Applied Linguistics
Faculty of Mathematics and Physics, Charles University
{cinkova, strakova}@ufal.mff.cuni.cz
Download at hdl.handle.net/11234/1-1713 
Project URL:  https://ufal.mff.cuni.cz/wordsim353-cs 
Licence: CC-BY, International 4.0
Support: Czech Science Foundation (GA-15-20031S), Grant Agency of the Czech Academy of Sciences (1ET201120505), Charles University (PRVOUK P46), Czech Ministry of Education, Youth and Sports (LINDAT-CLARIN LM2015071)
=================================================================================================
======Introduction
Recent years have seen a substantial interest in vector space modeling applied to lexical similarity or lexical relatedness, also in multilingual terms. A number of human judgment datasets have been created to evaluate the available semantic metrics and make sure that the metrics would simulate the human lexical simiarity/relatedness reasoning. One of the first and best-known datasets of this kind is WordSim353 (Finkelstein et al., 2009). It has also been translated into several other languages: Arabic, Spanish, Romanian (Hassan and Mihalcea, 2009), and most recently also to Russian, Italian, and German (Leviant and Reichart, 2015). To the best of our knowledge, there has not been anyWordSim353 translation to Czech so far; therefore we have created one. 
======Format
We had our 25 annotators score all translation variants of each original English word pair (by 4 translators, resulting in 634 different word-pairs). The WordSim353-cs data set comes thus in two different files: "WordSim353-cs.csv" and "WordSim-cs-Multi.csv". Both files are encoded in UTF-8, have a header, text is enclosed in double quotes, and columns are separated by commas. The rows are numbered. The WordSim-cs-Multi data set has rows numbered from 1 to 634, whereas the row indices in the WordSim353-cs data set reflect the corresponding row numbers in the WordSim-cs-Multi data set.

The WordSim353-cs file contains a one-to-one mapping selection of 353 Czech equivalent pairs whose judgments have proven to be most similar to the judgments of their corresponding English originals (compared by the absolute value of the difference between the means over all annotators in each language counterpart). In one case ("psychology-cognition"), two Czech equivalent pairs had identical means as well as confidence intervals, so we randomly selected one. 

The "WordSim-cs-Multi.csv" file contains human judgments for all translation variants. 

In both data sets, we preserved all 25 individual scores. In the WordSim353-cs data set, we added a column with their Czech means as well as a column containing the original English means and 95% confidence intervals in separate columns for each mean (computed by the CI function in the Rmisc R package). The WordSim-cs-Multi data set contains only the Czech means and confidence intervals. For the most convenient lexical search, we provided separate columns with the respective Czech and English single words, entire word pairs, and eventually an English-Czech quadruple in both data sets.

The data set also contains an xls table with the four translations and a preliminary selection of the best variants performed by an adjudicator.
======Feedback, Requests, Contact  
For further inquiries about this data set or feedback feel free to contact Silvie Cinkova (cinkova@ufal.mff.cuni.cz). 

======References
References
(Agirre et al., 2009)	E. Agirre, E. Alfonseca, K.B. Hall, Jana Kravalová, M. Pasca, A. Soroa. 2009. A Study on Similarity and Relatedness Using Distributional and WordNet-based Approaches. In: Proceedings of NAACL-HLT 09, Boulder, CO, USA, ISBN 978-1-932432-41-1, pp. 19-27.

(Finkelstein et al., 2001)  L. Finkelstein, E. Gabrilovich, Y. Matias, E. Rivlin, Z. Solan, G. Wolfman and E. Ruppin. 2001. Placing search in context: the concept revisited. In Proceedings of the Conference on the World Wide Web, pages 406-414.

(Hassan and Mihalcea, 2009) S. Hassan and R. Mihalcea. 2009. Cross-lingual Semantic Relatedness Using Encyclopedic Knowledge. In Proceedings of the conference on Empirical Methods in Natural Language Processing, Singapore

(Leviant and Reichart, 2015) I. Leviant and R. Reichart. 2015. Separated by an Un-common Language: Towards Judgment Language Informed Vector Space Modeling. arXiv>1508.001.06v5 [cs.CL]. 

======Citation Info
If you use this data set, please cite these three papers: 

S. Cinková: WordSim353 for Czech. 2016. In: Text, Speech and Dialogue, Proceedings of the 19th International Conference TSD 2016. LNAI series. 

@INCOLLECTION{cinkova_wsim_cs,
 author = {Silvie Cinkov\'{a}},
 title = {WordSim353 for Czech},
 year = {2016},
 publisher = {Springer},
 address = {Berlin-Heidelberg, Germany},
 pages = {190--198},
 booktitle = {Text, Speech and Dialogue, Proceedings of the 19th International Conference TSD 2016},
 series = {Lecture Notes in Artificial Intelligence},
 
}


E. Agirre, E. Alfonseca, K.B. Hall, Jana Kravalová, M. Pasca, A. Soroa. 2009. A Study on Similarity and Relatedness Using Distributional and WordNet-based Approaches. In: Proceedings of NAACL-HLT 09, Boulder, CO, USA, ISBN 978-1-932432-41-1, pp. 19-27.

@inproceedings{Agirre:2009:SSR:1620754.1620758,
 author = {Agirre, Eneko and Alfonseca, Enrique and Hall, Keith and Kravalova, Jana and Pa\c{s}ca, Marius and Soroa, Aitor},
 title = {A Study on Similarity and Relatedness Using Distributional and WordNet-based Approaches},
 booktitle = {Proceedings of Human Language Technologies: The 2009 Annual Conference of the North American Chapter of the Association for Computational Linguistics},
 series = {NAACL '09},
 year = {2009},
 isbn = {978-1-932432-41-1},
 location = {Boulder, Colorado},
 pages = {19--27},
 numpages = {9},
 url = {http://dl.acm.org/citation.cfm?id=1620754.1620758},
 acmid = {1620758},
 publisher = {Association for Computational Linguistics},
 address = {Stroudsburg, PA, USA},
} 

 L. Finkelstein, E. Gabrilovich, Y. Matias, E. Rivlin, Z. Solan, G. Wolfman and E. Ruppin. 2002. "Placing Search in Context: The Concept Revisited", ACM Transactions on Information Systems, 20(1):116-131, January 2002.
 
 @article{2002:PSC:503104.503110,
 title = {Placing Search in Context: The Concept Revisited},
 journal = {ACM Trans. Inf. Syst.},
 issue_date = {January 2002},
 volume = {20},
 number = {1},
 month = jan,
 year = {2002},
 issn = {1046-8188},
 pages = {116--131},
 numpages = {16},
 url = {http://doi.acm.org/10.1145/503104.503110},
 doi = {10.1145/503104.503110},
 acmid = {503110},
 publisher = {ACM},
 address = {New York, NY, USA},
 keywords = {Search, context, invisible web, semantic processing, statistical natural language processing},
key = {{$\!\!$}} ,
} 

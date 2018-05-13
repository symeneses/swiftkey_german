German SwiftKey
========================================================
author: Sandra Meneses
date: 13.05.2018
autosize: true


How is it predicting?
========================================================

- Use data from diffent sources: Blogs, news and twitter.
- Cleaning and counting word sequences.
- Selecting only the most common.
- Giving priority to different options: sequences of 3 words, 2 words, etc.
- By default showing the most common words.

Some examples
========================================================

Here we can see how the model predicts based on the text:


```r
text <- "ich"
nextWords(text)
```

```
[1] "bin"  "habe" "mich"
```

```r
text <- "ich bin ein"
nextWords(text)
```

```
[1] "großer" "sehr"   "freund"
```

```r
text <- ". "
nextWords(text)
```

```
[1] "die" "der" "und"
```

How to use the model
========================================================

Go to the link [here](https://symeneses.shinyapps.io/SwiftKey_German/)

And type!

You will see always 3 words as suggestions for the next one!

And the final prediction! Easy! Isn't it?


Conclusions & Future Improvements
========================================================

After finishing this project, the team can conclude:

- The predictions are fast and accurate enought to help users.
- Analysis of German language was useful to reduce the number of words and by doing so, the memory required to save the data.
- The model can be applied to other language with no major effort.

Out team needs the support to continue with these ideas:

- Use word embeddings like word2vec to get better predictions for words that are not in the corpora.
- Include corpora with part of the speech tags to take probabilities of sequences (for example Verb -> Object -> Preposition) into consideration.
- Implementation of Recurrent Neural Networks (RNN) to predict the next word.

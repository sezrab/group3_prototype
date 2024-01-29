// generate dummy data for testing, from a random selection of data

import 'dart:math';

import 'package:group3_prototype/models/article.dart';

List<String> authors = [
  // LIST OF FAMOUS NLP RESEARCHERS
  'Yoshua Bengio',
  'Christopher Manning',
  'Dan Jurafsky',
  'Richard Socher',
  'Jacob Devlin',
  'Sebastian Ruder',
  'Jason Weston',
  'Tomas Mikolov',
  'Jeffrey Pennington',
  'Ronan Collobert',
  'Quoc Le',
  'Oriol Vinyals',
  'Andrew Ng',
  'Geoffrey Hinton',
  'Yann LeCun',
  'Francois Chollet',
  'Andrej Karpathy',
  'Ian Goodfellow',
  'Fei-Fei Li',
];

List<String> titles = [
  // famous NLP papers
  'Dynamic Pooling and Unfolding Recursive Autoencoders for Paraphrase Detection',
  'Natural Language Processing (almost) from Scratch',
  'Recursive Deep Models for Semantic Compositionality Over a Sentiment Treebank',
  'A Neural Probabilistic Language Model',
  'Efficient Estimation of Word Representations in Vector Space',
  'Distributed Representations of Words and Phrases and their Compositionality',
  'GloVe: Global Vectors for Word Representation',
  'Learning Word Vectors for Sentiment Analysis',
  'Distributed Representations of Sentences and Documents',
  'Bag of Tricks for Efficient Text Classification',
  'Convolutional Neural Networks for Sentence Classification',
  'A Convolutional Neural Network for Modelling Sentences',
  'A Sensitivity Analysis of (and Practitioners Guide to) Convolutional Neural Networks for Sentence Classification',
  'A Fast and Accurate Dependency Parser using Neural Networks',
  'The Best of Both Worlds: Combining Recent Advances in Neural Machine Translation',
  'Attention Is All You Need',
  'BERT: Pre-training of Deep Bidirectional Transformers for Language Understanding',
  'Deep contextualized word representations',
  'Language Models are Unsupervised Multitask Learners',
];

List<String> loremIpsum = [
  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ',
  'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. ',
  'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
  'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.',
  'Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? ',
  'Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?',
];

List<String> tags = [
  'Deep Learning',
  'Natural Language Processing',
  'LLMs in Healthcare',
  'GPT-3',
  'BERT',
  'Recurrent Neural Networks',
  'Convolutional Neural Networks',
  'Transformer Networks',
  'Reinforcement Learning',
  'Generative Adversarial Networks',
  'Self-Supervised Learning',
  'Text Classification',
  'Sentiment Analysis'
];
ArticleData randomArticle() {
  // generate random article
  var rd = Random();
  return ArticleData(
      title: titles[rd.nextInt(titles.length)],
      author: authors[rd.nextInt(authors.length)],
      description: loremIpsum[rd.nextInt(loremIpsum.length)],
      url: 'https://www.google.com',
      // between 1 and 3 random tags
      tags: List.generate(
          rd.nextInt(3) + 1, (index) => tags[rd.nextInt(tags.length)]),
      publishedAt: DateTime.now());
}

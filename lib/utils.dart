// lib/utils.dart

import 'dart:math';

/// Compare two embeddings and return true if they are close enough (same person)
bool isSamePerson(List<double> emb1, List<double> emb2, {double threshold = 1.0}) {
  if (emb1.length != emb2.length) return false;

  double sum = 0;
  for (int i = 0; i < emb1.length; i++) {
    sum += pow((emb1[i] - emb2[i]), 2);
  }
  double euclideanDistance = sqrt(sum);
  return euclideanDistance < threshold;
}

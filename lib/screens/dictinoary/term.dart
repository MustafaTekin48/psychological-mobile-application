class Term {
  final int id;
  final String term;
  final String definition;

  Term({required this.id, required this.term, required this.definition});

  factory Term.fromMap(Map<String, dynamic> json) {
    return Term(
      id: json['id'],
      term: json['term'],
      definition: json['definition'],
    );

  }

}


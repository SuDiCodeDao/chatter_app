class Param {
  String name;
  dynamic value;

  Param(this.name, this.value);
  @override
  String toString() {
    return '{ $name, $value }';
  }
}

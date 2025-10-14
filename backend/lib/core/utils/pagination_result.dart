class PaginationResult<T> {
  final List<T> items;
  final int total;

  PaginationResult(this.items, this.total);
}

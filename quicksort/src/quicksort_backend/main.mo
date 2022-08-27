import Array "mo:base/Array";
import Nat "mo:base/Nat";

actor {
  func swap(arr: [var Int], i: Nat, j: Nat) {
    let tmp = arr[i];
    arr[i] := arr[j];
    arr[j] := tmp;
  };

  // 区间分割
  func partition(arr: [var Int], _first: Nat, _last: Nat, pivot: Int): Nat {
    var first = _first;
    var last = _last;
    loop {
      while (arr[first] < pivot) {
        first := first + 1;
      };
      last := last - 1;
      while (pivot < arr[last]) {
        last := last - 1;
      };
      if (first >= last) {
        return first;
      };
      swap(arr, first, last);
      first := first +1;
    }
  };

  // 递归排序
  func quicksortInPlace(arr: [var Int], _first: Nat, last: Nat) {
    var first = _first;
    while (last > first) {
      let pivot = arr[first];
      let split = partition(arr, first, last, pivot);
      quicksortInPlace(arr, first, split - 1);
      first := split + 1;
    };
  };

  public func qsort(arr: [Int]): async [Int] {
    let tmp :[var Int] = Array.thaw(arr);
    quicksortInPlace(tmp, 0, tmp.size()-1);
    Array.freeze(tmp)
  };
};

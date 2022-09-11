import Int "mo:base/Int";
import Quicksort "Quicksort";

actor Main {

  // Sort an array of integers.
  public query func qsort(xs : [Int]) : async [Int] {
    return Quicksort.sortBy(xs, Int.compare);
  };
};

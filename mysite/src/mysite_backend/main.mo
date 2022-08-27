import Nat "mo:base/Nat";

actor {
  public func fibonacci(n: Nat) : async Text {
    "fib(" # Nat.toText(n) # ") = " # Nat.toText(fib(n))
  };

  func fib(n: Nat): Nat {
    if (n <= 1) {
      1
    } else {
      fib(n-1) + fib(n-2)
    }
  };
};

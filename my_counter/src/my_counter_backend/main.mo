import Nat "mo:base/Nat";
import Text "mo:base/Text";
actor Counter {
  stable var currentValue : Nat = 0;

  // Increment the counter with the increment function.
  public func increment() : async () {
    currentValue += 1;
  };

  // Read the counter value with a get function.
  public query func get() : async Nat {
    currentValue;
  };

  // Write an arbitrary value with a set function.
  public func set(n : Nat) : async () {
    currentValue := n;
  };

  type HeaderField = (Text, Text);
  type HttpRequest = {
    body : Blob;
    headers : [HeaderField];
    method : Text;
    url : Text;
  };

  type HttpResponse = {
    body : Blob;
    headers : [HeaderField];
    status_code : Nat16;
    streaming_strategy : ?StreamingStrategy;
  };

  public type StreamingStrategy = {
    #Callback : {
      token : StreamingCallbackToken;
      callback : shared query StreamingCallbackToken -> async StreamingCallbackHttpResponse;
    };
  };

  public type StreamingCallbackToken = {
    key : Text;
    sha256 : ?[Nat8];
    index : Nat;
    content_encoding : Text;
  };

  public type StreamingCallbackHttpResponse = {
    token : ?StreamingCallbackToken;
    body : Text;
  };

  public query func http_request(request : HttpRequest) : async HttpResponse {
    {
      body = Text.encodeUtf8("<html> <body> <h1> currentValue: (" # Nat.toText(currentValue) # ") </h1></body></html>");  //Nat convert Text
      headers = [("Content-Type", "text/html")];
      status_code = 200;
      streaming_strategy = null;
    };
  };
};

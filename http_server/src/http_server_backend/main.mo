import Text "mo:base/Text";

actor {
  public func greet(name : Text) : async Text {
    return "Hello, " # name # "!";
  };
  type HttpRequest = {
    body: Blob;
    headers: [HeaderField];
    method: Text;
    url: Text;
  };

  type HttpResponse = {
    body: Blob;
    headers: [HeaderField];
    status_code: Nat16;
  };

  type HeaderField = (Text, Text);

  public query func http_request(arg: HttpRequest): async HttpResponse {
    {
      body = Text.encodeUtf8("Hello Wrold!");
      headers = [];
      status_code = 200;
    }
  }
};

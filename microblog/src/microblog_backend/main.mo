import List "mo:base/List";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Time "mo:base/Time";
import Debug "mo:base/Debug";

actor {
  public type Message = {
    text : Text;
    time : Time.Time;
  };

  public type Microblog = actor {
    // 添加关注对象
    follow : shared (Principal) -> async ();
    // 返回关注列表
    follows : shared query () -> async [Principal];
    // 发布新消息
    post : shared (Text) -> async ();
    // 返回所有发布的消息
    posts : shared query (Time.Time) -> async [Message];
    // 返回所有关注对象发布的消息
    timeline : shared (Time.Time) -> async [Message];
  };

  stable var followed : List.List<Principal> = List.nil();

  public shared func follow(id : Principal) : async () {
    followed := List.push(id, followed);
  };

  public shared query func follows() : async [Principal] {
    List.toArray(followed);
  };

  stable var messages : List.List<Message> = List.nil();

  public shared (msg) func post(text : Text) : async () {
    Debug.print(debug_show(Principal.toText(msg.caller)));
    // 限制调用方必须为自己: dfx identity get-principal
    assert(Principal.toText(msg.caller) =="o7tmu-26wam-t3utw-l5jsi-3qpco-s3hoy-wk5io-yt4o7-7o3yg-r62gb-bqe");
    let new_post : Message = {
      text = text;
      time = Time.now();
    };
    messages := List.push(new_post, messages);
  };

  public shared query func posts(since : Time.Time) : async [Message] {
    var sinceMsg : List.List<Message> = List.nil();
    for (msg in Iter.fromList(messages)) {
      if (msg.time > since) {
        sinceMsg := List.push(msg, sinceMsg);
      };
    };
    List.toArray(sinceMsg);
  };

  public shared func timeline(since : Time.Time) : async [Message] {
    var all : List.List<Message> = List.nil();
    for (id in Iter.fromList(followed)) {
      let canister : Microblog = actor (Principal.toText(id));
      let msgs = await canister.posts(since);
      for (msg in Iter.fromArray(msgs)) {
        all := List.push(msg, all);
      };
    };

    List.toArray(all);
  };
};

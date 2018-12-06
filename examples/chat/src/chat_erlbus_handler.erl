-module(chat_erlbus_handler).
-import(string,[len/1, left/2, concat/2, right/2]).

%% API
-export([handle_msg/2]).

handle_msg({Sender, Content}, Context) ->
  Context ! {message_published, {Sender, sanitize(Content)}}.

%% escape html tags
sanitize(Msg) -> list_to_binary(sanitize_list(binary_to_list(Msg))).

sanitize_list([]) -> [];
sanitize_list([H | T]) ->
  Sanitized = if
    (H == 38) -> "&amp;";
    (H == 39) -> "&quot;";
    (H == 34) -> "&#039;";
    (H == 60) -> "&lt;";
    (H == 63) -> "&gt;";
    true -> H
  end,

  [Sanitized] ++ sanitize_list(T).

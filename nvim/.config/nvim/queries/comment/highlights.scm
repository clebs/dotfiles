; extends

((tag
  (name) @comment.bonfire @nospell
  ("(" @punctuation.bracket
    (user) @constant
    ")" @punctuation.bracket)?
  ":" @punctuation.delimiter)
  (#eq? @comment.bonfire "BONFIRE"))

("text" @comment.bonfire @nospell
  (#eq? @comment.bonfire "BONFIRE"))

((tag
  (name) @comment.bug @nospell
  ("(" @punctuation.bracket
    (user) @constant
    ")" @punctuation.bracket)?
  ":" @punctuation.delimiter)
  (#eq? @comment.bug "BUG"))

("text" @comment.bug @nospell
  (#eq? @comment.bug "BUG"))

((tag
  (name) @comment.note @nospell
  ("(" @punctuation.bracket
    (user) @constant
    ")" @punctuation.bracket)?
  ":" @punctuation.delimiter)
  (#eq? @comment.note "NOTE"))

("text" @comment.note @nospell
  (#eq? @comment.note "NOTE"))

((tag
  (name) @comment.fixme @nospell
  ("(" @punctuation.bracket
    (user) @constant
    ")" @punctuation.bracket)?
  ":" @punctuation.delimiter)
  (#eq? @comment.fixme "FIXME"))

("text" @comment.fixme @nospell
  (#eq? @comment.fixme "FIXME"))

((tag
  (name) @comment.xxx @nospell
  ("(" @punctuation.bracket
    (user) @constant
    ")" @punctuation.bracket)?
  ":" @punctuation.delimiter)
  (#eq? @comment.xxx "XXX"))

("text" @comment.xxx @nospell
  (#eq? @comment.xxx "XXX"))


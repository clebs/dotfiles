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


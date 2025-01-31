local snippets = {
  {
    trigger = "errnil",
    description = "Error handling boilerplate",
    body = [[
if ${1}err != nil {
  return err
}
]],
  },
}

return snippets

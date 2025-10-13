-- Place your snippets for go here. Each snippet is defined under a snippet name and has a trigger, body and
-- description. The trigger is what is used to trigger the snippet and the body will be expanded and inserted.
--
-- Possible variables are:
-- $1, $2 for tab stops, $0 for the final cursor position, and ${1:label}, ${2:another} for placeholders.
-- Placeholders with the same ids are connected.

local snippets = {
  {
    trigger = "errnil",
    description = "Error handling boilerplate",
    body = [[
if ${1:err} != nil {
  return ${2:err}
}
  ]],
  },

  {
    trigger = "conderrnil",
    description = "Condensed error nil check",
    body = [[
if err := $1; err != nil {
  return ${2:err}
}
    ]],
  },

  {
    trigger = "unit",
    description = "Unit test",
    body = [[
func Test$1(t *testing.T) {
  $0
}
  ]],
  }

}

return snippets

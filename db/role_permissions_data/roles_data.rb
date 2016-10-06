ROLES = ActiveSupport::OrderedHash.new()

ROLES["Admin"] = [
    {name: 'Product-Admin'},
    {name: 'School-Admin'}
]

ROLES["USER"] = [
    {name: 'Teacher'},
    {name: 'Parent'}
]
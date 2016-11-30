ROLES = ActiveSupport::OrderedHash.new()

ROLES["Admin"] = [
    {name: 'product-admin'},
    {name: 'school-admin'}
]

ROLES["USER"] = [
    {name: 'teacher'},
    {name: 'parent'}
]
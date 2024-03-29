class Device extends share.BaseDocument
  # registeredAt
  # uuid: UUID of the device
  # token: token of the device
  # thing: a model of the device and its api
  # owner:
  #   _id
  # environment: the place a thing belongs too.
  #   _id
  # onlineSince

  @Meta
    name: 'Device'
    fields: =>
      owner: @ReferenceField User, [], false
      # environment: @ReferenceField Environment, ['uuid']
    
# class Device extends Device
#   @Meta
#     name: 'Device'
#     replaceParent: true
#     fields: (fields) =>
#       fields.environment = @ReferenceField Environment, [], true, 'devices'
#       fields

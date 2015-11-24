class Device.ListComponent extends UIComponent
  @register 'Device.ListComponent'

  onCreated: ->
    super

    @canNew = new ComputedField =>
      !!Meteor.userId()

    @subscribe 'Device.list'

  devicesList: ->
    Device.documents.find()

class Device.ListItemComponent extends UIComponent
  @register 'Device.ListItemComponent'
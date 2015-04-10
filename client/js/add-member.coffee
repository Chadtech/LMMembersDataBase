# Libraries
React   = require 'react'
Parse   = require('parse').Parse

# DOM Elements
{p, a, div, input, img} = React.DOM


AddMember  = React.createClass



  getInitialState: ->
    firstName:  ''
    lastName:   ''
    photo:      ''
    doc:        ''

    permitSubmitPhoto: true
    permitSubmitDoc:   true
    submitClass:       'submit'

  handleSubmit: ->
    if @state.permitSubmitDoc and @state.permitSubmitPhoto

      Member    = Parse.Object.extend 'Member'
      newMember = new Member()

      newMember.set 'TIG',          false
      newMember.set 'MIG',          false
      newMember.set 'laser',        false
      newMember.set 'smallCNCMill', false
      newMember.set 'photo',        @state.photo
      newMember.set 'doc',          @state.doc
      newMember.set 'firstName',    @state.firstName
      newMember.set 'lastName',     @state.lastName

      newMember.save null, 
        success: =>
          location.reload()
        error: (error) ->
          console.log 'ERROR', error


  handleFirstName: (event) ->
    @setState firstName: event.target.value


  handleLastName: (event) ->
    @setState lastName: event.target.value


  handlePhoto: (event) ->
    @setState permitSubmitPhoto: false, ->
      @wait()

    reader = new FileReader()
    file   = event.target.files[0]

    photo = new Parse.File 'image.png', file

    photo.save().then =>
      @setState photo: photo._url
      @setState permitSubmitPhoto: true, ->
        @wait()


  handleDoc: (event) ->
    @setState permitSubmitDoc: false, ->
      @wait()

    reader = new FileReader()
    file   = event.target.files[0]

    doc = new Parse.File 'image.png', file

    doc.save().then =>
      @setState doc: doc._url
      @setState permitSubmitDoc: true, ->
        @wait()


  wait: ->
    if @state.permitSubmitPhoto and @state.permitSubmitDoc
      @setState submitClass: 'submit'
    else
      @setState submitClass: 'submit wait'



  render: ->

    div 
      className: 'section'


      input
        className:    'input'
        placeholder:  'first name'
        style:
          display:    'inline-block'
        value:        @state.firstName
        onChange:     @handleFirstName

      input
        className:    'input'
        placeholder:  'last name'
        style:
          display:    'inline-block'
          marginLeft: '1em'
        value:        @state.lastName
        onChange:     @handleLastName

      p
        className:    'point'
        style:
          marginLeft: '1em'
          display:    'inline-block'
        'Photo:'

      input
        type:         'file'
        onChange:     @handlePhoto
        style:
          marginLeft: '1em'

      p
        className:    'point'
        style:
          marginLeft: '1em'
          display:    'inline-block'
        'Document:'

      input
        type:         'file'
        onChange:     @handleDoc
        style:
          marginLeft: '1em'


      input
        className:    @state.submitClass
        style:
          marginLeft: '1em'
        type:         'submit'
        value:        'Add Member'
        onClick:      @handleSubmit



module.exports = React.createFactory AddMember



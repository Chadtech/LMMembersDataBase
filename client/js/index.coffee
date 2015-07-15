# Libraries
React = require 'react'
_     = require 'lodash'
Parse = require('parse').Parse
Parse.initialize "0wKSaP3SaJy0wl8pxjFRnXGSqTQgLkFVeOspAaBs", "OqwaDAm6NUz6DQOfwzBBv3kerjqbvqoi2eMxNsSg"


AddMember  = require './add-member.coffee'
MemberView = require './member-view.coffee'
Search     = require './search.coffee'

# DOM Elements
{p, a, div, input, img} = React.DOM

# Dank Memes (all day long)


IndexClass = React.createClass


  getInitialState: ->

    Member = Parse.Object.extend 'Member'
    query = new Parse.Query Member 
    setMembers = (results) =>
      @setState members: results

    query.find
      success: setMembers
      error: (error) ->
        console.log error

    initialState =
      members:  []
      loggedIn: false
      username: ''
      password: ''

    initialState


  SetTIG: (event) ->
    if event.target.getAttribute 'data-permit'
      memberIndex = event.target.getAttribute 'data-index'
      @state.members[memberIndex].attributes.TIG = not @state.members[memberIndex].attributes.TIG
      @setState members: @state.members


  SetMIG: (event) ->
    if event.target.getAttribute 'data-permit'
      memberIndex = event.target.getAttribute 'data-index'
      @state.members[memberIndex].attributes.MIG = not @state.members[memberIndex].attributes.MIG
      @setState members: @state.members


  SetLaser: (event) ->
    if event.target.getAttribute 'data-permit'
      memberIndex = event.target.getAttribute 'data-index'
      @state.members[memberIndex].attributes.laser = not @state.members[memberIndex].attributes.laser
      @setState members: @state.members


  SetSmallCNCMill: (event) ->
    if event.target.getAttribute 'data-permit'
      memberIndex = event.target.getAttribute 'data-index'
      @state.members[memberIndex].attributes.smallCNCMill = not @state.members[memberIndex].attributes.smallCNCMill
      @setState members: @state.members


  Set3DPrinters: (event) ->
    if event.target.getAttribute 'data-permit'
      memberIndex = event.target.getAttribute 'data-index'
      @state.members[memberIndex].attributes.t3DPrinters = not @state.members[memberIndex].attributes.t3DPrinters
      @setState members: @state.members


  SetOrientation: (event) ->
    if event.target.getAttribute 'data-permit'
      memberIndex = event.target.getAttribute 'data-index'
      @state.members[memberIndex].attributes.oriented = not @state.members[memberIndex].attributes.oriented
      @setState members: @state.members


  usernameHandle: (event) ->
    @setState username: event.target.value


  passwordHandle: (event) ->
    @setState password: event.target.value


  login: ->

    login = =>
      @setState loggedIn: true

    Parse.User.logIn @state.username, @state.password,
      success: (user) =>
        login()

      error: (user, error) =>
        console.log 'NOPE', user, error


  SaveMember: (index, id, next) ->
    Member = Parse.Object.extend 'Member'

    thisMember = new Member()
    thisMember.id = id

    thisMember.set 'TIG',          @state.members[index].attributes.TIG
    thisMember.set 'MIG',          @state.members[index].attributes.MIG
    thisMember.set 'laser',        @state.members[index].attributes.laser
    thisMember.set 'smallCNCMill', @state.members[index].attributes.smallCNCMill
    thisMember.set 't3DPrinters',  @state.members[index].attributes.t3DPrinters
    thisMember.set 'waterjet',     @state.members[index].attributes.waterjet
    thisMember.set 'oriented',     @state.members[index].attributes.oriented

    thisMember.save null, 
      success: (result) ->
        console.log 'YE SUCESS', result 

    next()

  SearchName: (name) ->

    name = name.toLowerCase()

    filteredMembers = _.filter @state.members, (member) ->
      theirName = ''
      theirName += member.attributes.firstName
      theirName += ' '
      theirName += member.attributes.lastName
      theirName = theirName.toLowerCase()

      (theirName.indexOf name) isnt -1

    @setState members: filteredMembers

  handleTSV: (namesToAdd) ->

    namesOfMembers = _.map @state.members, (member) ->
      name = member.attributes.firstName
      name += ' '
      name += member.attributes.lastName
      name = name.toLowerCase()

    for name in namesToAdd
      name = name.toLowerCase()
      
      pointOfNameBreak = name.indexOf ' '
      theirFirstName = name.substring 0, pointOfNameBreak
      theirLastName  = name.substring pointOfNameBreak

      if not (name in namesOfMembers)
        Member    = Parse.Object.extend 'Member'
        newMember = new Member()

        newMember.set 'TIG',          false
        newMember.set 'MIG',          false
        newMember.set 'laser',        false
        newMember.set 'smallCNCMill', false
        newMember.set 't3DPrinters',  false
        newMember.set 'waterjet',     false
        newMember.set 'oriented',     false

        newMember.set 'firstName',    theirFirstName
        newMember.set 'lastName',     theirLastName

        newMember.save null, 
          success: =>
            # location.reload()
          error: (error) ->
            console.log 'ERROR', error



  render: ->

    div null,
      div className: 'indent',
        div className: 'spacer'

        div
          className: 'banner'
          p
            className: 'header'
            'LM Labs Chandler Member Database'

        div
          className: 'spacer'


        if @state.loggedIn

          AddMember()

        if @state.loggedIn

          Search
            search: @SearchName
            TSV:    @handleTSV

        if @state.loggedIn

          _.map @state.members, (member, memberIndex) =>
            MemberView 
              member:           member.attributes
              memberIndex:      memberIndex
              SetTIG:           @SetTIG
              SetMIG:           @SetMIG
              SetLaser:         @SetLaser
              SetSmallCNCMill:  @SetSmallCNCMill
              Set3DPrinters:    @Set3DPrinters
              SetOrientation:   @SetOrientation
              SaveMember:       @SaveMember
              memberId:         member.id

        else

          div className: 'section',

            input
              className:    'input'
              placeholder:  'username'
              style:
                display:    'inline-block'
              value:        @state.username
              onChange:     @usernameHandle

            input
              className:    'input'
              placeholder:  'password'
              type:         'password'
              style:
                marginLeft: '1em'
                display:    'inline-block'
              value:        @state.password
              onChange:     @passwordHandle

            input
              className: 'submit'
              style:
                marginLeft: '1em'
                display:    'inline-block'
              type:         'submit'
              value:        'log in'
              onClick:      @login





App = React.createElement IndexClass

React.render App, (document.getElementById 'content')



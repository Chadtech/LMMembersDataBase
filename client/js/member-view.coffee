# Libraries
React   = require 'react'
Parse   = require('parse').Parse


# DOM Elements
{p, a, div, input, img} = React.DOM



eachCell = (sectionType, member) ->

  output =
    display:    'inline-block'
    marginLeft: '0.5em'
    width: 125

  switch sectionType
    when true
      output.backgroundColor = "#30ff49"
    when false
      output.backgroundColor = '#ff4930'

  output



MemberView  = React.createClass


  getInitialState: ->
    edit: false
    editName: 'Edit'
    margins: 0.5
    member: @

  editSet: ->
    @setState edit: not @state.edit

    switch @state.editName

      when 'Edit'
        @setState editName: 'Save'
        @setState margins: 1
      
      when 'Save'

        returnToEdit = =>
          @setState editName: 'Edit'
          @setState margins: 0.5

        @props.SaveMember @props.memberIndex, @props.memberId, returnToEdit




  render: ->

    div 
      className: 'section'
      style:
        marginTop:    @state.margins + 'em'
        marginBottom: @state.margins + 'em'

      div
        style:
          display: 'table'
        div
          style:
            display:    'inline-block'
            marginLeft: '0.5em'
            width: 200

          p
            className: 'point'
            style:
              marginLeft: '1em'
              display: 'inline-block'
            @props.member.firstName + ' ' + @props.member.lastName


        div
          style:
            eachCell( @props.member.TIG )

          p
            className: 'point'
            style:
              textAlign: 'center'
              cursor: 'pointer'
            onClick: @props.SetTIG
            'data-index': @props.memberIndex
            'data-permit': @state.edit

            'TIG'

        div
          style:
            eachCell( @props.member.MIG )

          p
            className: 'point'
            style:
              textAlign: 'center'
              cursor: 'pointer'
            onClick: @props.SetMIG
            'data-index': @props.memberIndex
            'data-permit': @state.edit

            'MIG'

        div
          style:
            eachCell( @props.member.laser)

          p
            className: 'point'
            style:
              textAlign: 'center'
              cursor: 'pointer'
            onClick: @props.SetLaser
            'data-index': @props.memberIndex
            'data-permit': @state.edit

            'Laser'

        div
          style:
            eachCell( @props.member.smallCNCMill)

          p
            className: 'point'
            style:
              textAlign: 'center'
              cursor: 'pointer'
            onClick: @props.SetSmallCNCMill
            'data-index': @props.memberIndex
            'data-permit': @state.edit

            'Small CNC Mill'

        input
          className: 'submit'
          style:
            marginLeft: '1em'
          type: 'submit'
          value: @state.editName
          onClick: @editSet

      div
        style:
          display: 'table'

        div
          style:
            display:    'inline-block'
            marginLeft: '0.5em'
            width: 100

          a
            className: 'exit'
            href: @props.member.photo
            style:
              cursor: 'pointer'
              marginLeft: '1em'
              display: 'inline-block'
            'Photo'

        div
          style:
            display:    'inline-block'
            marginLeft: '0.5em'
            width: 100

          p
            className: 'exit'
            href: @props.member.doc
            style:
              cursor: 'pointer'
              marginLeft: '1em'
              display: 'inline-block'
            'Document'



module.exports = React.createFactory MemberView



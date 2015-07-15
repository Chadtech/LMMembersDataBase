# Libraries
React   = require 'react'
Parse   = require('parse').Parse

# DOM Elements
{p, a, div, input, img} = React.DOM


Search  = React.createClass



  getInitialState: ->
    name: ''


  handleName: (event) ->
    @setState name: event.target.value


  handleSearch: (event) ->
    @props.search @state.name
    
  handleTSV: (event) ->

    reader = new FileReader()
    file   = event.target.files[0]

    reader.onload = (eventON) =>
      names = []
      for row in eventON.target.result.split '\n'
        columns = row.split '\t'
        names.push columns[1]
      @props.TSV names

    reader.readAsText file


  render: ->

    div 
      className: 'section'

      input
        className:    'input'
        placeholder:  'name'
        style:
          display:    'inline-block'
        value:        @state.name
        onChange:     @handleName

      input
        className:    'submit'
        style:
          marginLeft: '1em'
        type:         'submit'
        value:        'Search'
        onClick:      @handleSearch

      p
        className:    'point'
        style:
          marginLeft: '1em'
          display:    'inline-block'
        'CSV:'

      input
        type:         'file'
        onChange:     @handleTSV
        style:
          marginLeft: '1em'


module.exports = React.createFactory Search



if Meteor.isClient
    Router.route '/generate/:doc_id/edit', (->
        @layout 'layout'
        @render 'generate_edit'
        ), name:'generate_edit'

    Template.generate_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.generate_edit.onRendered ->
    Template.generate_edit.events
    Template.generate_edit.helpers

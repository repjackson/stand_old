if Meteor.isClient
    Router.route '/work/:doc_id/edit', (->
        @layout 'layout'
        @render 'work_edit'
        ), name:'work_edit'

    Template.work_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.work_edit.onRendered ->
    Template.work_edit.events
    Template.work_edit.helpers

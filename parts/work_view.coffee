if Meteor.isClient
    Router.route '/work/:doc_id/view', (->
        @layout 'layout'
        @render 'work_view'
        ), name:'work_view'

    Template.work_view.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id

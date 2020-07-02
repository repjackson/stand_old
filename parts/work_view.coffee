if Meteor.isClient
    Router.route '/generate/:doc_id/view', (->
        @layout 'layout'
        @render 'generate_view'
        ), name:'generate_view'

    Template.generate_view.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id

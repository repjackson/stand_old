if Meteor.isClient
    Router.route '/work/:doc_id/view', (->
        @layout 'layout'
        @render 'work_view'
        ), name:'work_view'

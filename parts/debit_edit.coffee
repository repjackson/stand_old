if Meteor.isClient
    Router.route '/debit/:doc_id/edit', (->
        @layout 'layout'
        @render 'debit_edit'
        ), name:'debit_edit'

    Template.debit_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.debit_edit.onRendered ->
    Template.debit_edit.events
        'click .delete_item': ->
            if confirm 'delete item?'
                Docs.remove @_id

    Template.debit_edit.helpers
    Template.debit_edit.events

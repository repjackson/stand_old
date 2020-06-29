if Meteor.isClient
    Router.route '/shop', (->
        @layout 'layout'
        @render 'shop'
        ), name:'shop'

    Template.shop.onCreated ->
        @autorun => Meteor.subscribe 'model_docs', 'item'
        @autorun => Meteor.subscribe 'all_users'

    Template.shop.helpers
        items: ->
            Docs.find
                model:'item'
    Template.shop.events
        'click .add_item': ->
            new_id =
                Docs.insert
                    model:'item'
            Router.go "/item/#{new_id}/edit"

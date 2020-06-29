if Meteor.isClient
    Router.route '/shop', (->
        @layout 'layout'
        @render 'shop'
        ), name:'shop'

    Template.shop.onCreated ->
        # Session.set 'username', null

    Template.shop.events
        'click .add_item': ->
            new_id =
                Docs.insert
                    model:'item'
            Router.go "/item/#{new_id}/edit"

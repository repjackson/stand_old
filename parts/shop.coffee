if Meteor.isClient
    Router.route '/shop', (->
        @layout 'layout'
        @render 'shop'
        ), name:'shop'

    Template.shop.onCreated ->
        # @autorun => Meteor.subscribe 'model_docs', 'shop'
        # @autorun => Meteor.subscribe 'all_users'
        @autorun -> Meteor.subscribe('shop_tag_results',
            selected_tags.array()
            selected_location_tags.array()
            selected_authors.array()
            Session.get('view_purchased')
            # Session.get('view_incomplete')
            )
        @autorun -> Meteor.subscribe('shop_results',
            selected_tags.array()
            selected_location_tags.array()
            selected_authors.array()
            Session.get('view_purchased')
            # Session.get('view_incomplete')
            )

    Template.shop.helpers
        shop_items: ->
            Docs.find
                model:'shop'
    Template.shop.events
        'click .add_shop': ->
            new_id =
                Docs.insert
                    model:'shop'
            Router.go "/shop/#{new_id}/edit"

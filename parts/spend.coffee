if Meteor.isClient
    Router.route '/spend', (->
        @layout 'layout'
        @render 'spend'
        ), name:'spend'

    Template.spend.onCreated ->
        # @autorun => Meteor.subscribe 'model_docs', 'spend'
        # @autorun => Meteor.subscribe 'all_users'
        @autorun -> Meteor.subscribe('spend_tag_results',
            selected_tags.array()
            selected_location_tags.array()
            selected_authors.array()
            Session.get('view_purchased')
            # Session.get('view_incomplete')
            )
        @autorun -> Meteor.subscribe('spend_results',
            selected_tags.array()
            selected_location_tags.array()
            selected_authors.array()
            Session.get('view_purchased')
            # Session.get('view_incomplete')
            )

    Template.spend.helpers
        spend_items: ->
            Docs.find
                model:'spend'
    Template.spend.events
        'click .add_spend': ->
            new_id =
                Docs.insert
                    model:'spend'
            Router.go "/spend/#{new_id}/edit"


    Template.spend_card.events
        'click .record_spend': ->
            Meteor.users.update Meteor.userId(),
                $inc: points:-@points
            $('body').toast({
                class: 'info',
                message: "#{@points} spent"
            })
            Docs.insert
                model:'spend_item'
                parent_id: @_id

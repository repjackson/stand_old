if Meteor.isClient
    Router.route '/', (->
        @layout 'layout'
        @render 'home'
        ), name:'home'

    Template.home.onCreated ->
        # @autorun => Meteor.subscribe 'model_docs', 'home'
        # @autorun => Meteor.subscribe 'all_users'
        @autorun -> Meteor.subscribe('home_tag_results',
            selected_tags.array()
            selected_location_tags.array()
            selected_authors.array()
            Session.get('view_purchased')
            # Session.get('view_incomplete')
            )
        @autorun -> Meteor.subscribe('home_results',
            selected_tags.array()
            selected_location_tags.array()
            selected_authors.array()
            Session.get('view_purchased')
            # Session.get('view_incomplete')
            )

    Template.home.helpers
        home_items: ->
            Docs.find
                model:'home'
    Template.home.events
        'click .add_home': ->
            new_id =
                Docs.insert
                    model:'home'
            Router.go "/home/#{new_id}/edit"


    # Template.home_card.events
    #     'click .record_home': ->
    #         Meteor.users.update Meteor.userId(),
    #             $inc: points:-@points
    #         $('body').toast({
    #             class: 'info',
    #             message: "#{@points} spent"
    #         })
    #         Docs.insert
    #             model:'home_item'
    #             parent_id: @_id

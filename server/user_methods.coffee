Meteor.methods
    calc_user_stats: (user_id)->
        user = Meteor.users.findOne user_id
        debit_count =
            Docs.find(
                model:'debit'
                _author_id: user_id
            ).count()

        credit_count =
            Docs.find(
                model:'debit'
                target_id: user_id
            ).count()

        Meteor.users.update user_id,
            $set:
                debit_count:debit_count
                credit_count:credit_count

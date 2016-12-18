'use strict'
module.exports = (sequelize, DataTypes) ->
	Target = sequelize.define 'webshot_target',
		keyword:
			type: Sequelize.STRING
		url:
			type: Sequelize.STRING
			field: 'url' # If set, sequelize will map the attribute name to a different name in the database
		left:
			type: Sequelize.INTEGER
		top:
			type: Sequelize.INTEGER
		width:
			type: Sequelize.INTEGER
		height:
			type: Sequelize.INTEGER
		channel:
			type: Sequelize.STRING

	return Target
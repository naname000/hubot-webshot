'use strict';
module.exports = function (sequelize, DataTypes) {
  var Target;
  Target = sequelize.define('Target', {
    keyword: {
      type: DataTypes.STRING
    },
    url: {
      type: DataTypes.STRING,
      field: 'url'
    },
    left: {
      type: DataTypes.INTEGER
    },
    top: {
      type: DataTypes.INTEGER
    },
    width: {
      type: DataTypes.INTEGER
    },
    height: {
      type: DataTypes.INTEGER
    },
    channel: {
      type: DataTypes.STRING
    }
  });
  return Target;
};

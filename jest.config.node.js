const pkg = require('./package.json');

module.exports = {
  testEnvironment: 'node',
  testMatch: ['**/*.spec.js'],
  collectCoverage: true,
  coverageDirectory,
  moduleNameMapper: {
    [`${pkg.name}/(.*)`]: '<rootDir>/$1',
  },
};

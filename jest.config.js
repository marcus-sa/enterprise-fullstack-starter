const pkg = require('./package.json');

module.exports = {
  testEnvironment: 'jsdom',
  testMatch: ['**/*.spec.js'],
  collectCoverage: true,
  setupFilesAfterEnv: ['jest-preset-angular'],
  moduleNameMapper: {
    [`${pkg.name}/(.*)`]: '<rootDir>/$1',
  },
};

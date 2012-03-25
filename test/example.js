
require('chai').should();

describe('Array', function() {
  return describe('#indexOf()', function() {
    return it('should return -1 when the value is not present', function() {
      [1, 2, 3].indexOf(5).should.equal(-1);
      return [1, 2, 3].indexOf(0).should.equal(-1);
    });
  });
});

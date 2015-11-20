/*jshint enforceall: true, jasmine: true*/
describe('Errorhandler module manages not catched exceptions.', function () {
    it('adds an error event listener in the window object. Checking it throwing an error.', function () {
        errorHandler.attachToWindow();
        spyOnEvent('window', 'error');
        var throwErr = function () {
            throw new Error("Jasmine test error.");
        };
        expect(throwErr).toThrow();
        expect('error').toHaveBeenTriggeredOn('window');
    });
});

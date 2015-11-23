/*jshint enforceall: true, jasmine: true*/
/*globals ajax*/


describe("Ajax module simplifies AJAX requests", function () {
    'use strict';

    beforeEach(function () {
       jasmine.Ajax.install();
    });

    afterEach(function () {
        jasmine.Ajax.uninstall();
    });

    it("should make an AJAX request to an valid URL and send a success callback", function () {
        var doneFn = jasmine.createSpy("success"),
            errorFn = jasmine.createSpy("error");

        ajax.request({
            method: 'Get',
            url: '/test/ok.html',
            success: function (response) {
                doneFn(response.responseText);
            },
            error: function (status) {
                errorFn(status);
            }
        });
        expect(jasmine.Ajax.requests.mostRecent().url).toBe('/test/ok.html');
        expect(doneFn).not.toHaveBeenCalled();
        expect(errorFn).not.toHaveBeenCalled();

        jasmine.Ajax.requests.mostRecent().respondWith({
            "status": 200,
            "contentType": 'text/plain',
            "responseText": 'Test OK'
        });

        expect(doneFn).toHaveBeenCalledWith('Test OK');
    });
    it("should send an error when it sends a non valid URL", function () {
        var doneFn = jasmine.createSpy("success"),
            errorFn = jasmine.createSpy("error");

        ajax.request({
            method: 'Get',
            success: function (response) {
                doneFn(response);
            },
            error: function (status) {
                errorFn(status);
            }
        });
        expect(jasmine.Ajax.requests.mostRecent().url).isUndefined;
        expect(doneFn).not.toHaveBeenCalled();
        expect(errorFn).toHaveBeenCalledWith(-2);
    });
});

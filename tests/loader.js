/*jshint enforceall: true, jasmine: true*/
/*globals loader*/

describe('Loader module helps to add (and delete) those Javascript/CSS/HTML fragments needed (unneeded).', function () {
    'use strict';

    beforeEach(function () {
       jasmine.Ajax.install();
    });

    afterEach(function () {
        jasmine.Ajax.uninstall();
    });

    it('Checks if a file is loaded into the application. This file does not exist, so the function must return false value.', function () {
        expect(document.querySelector('link[src="/test/noexists"]')).not.isDomNode;
        expect(loader.isLoaded('/test/noexists')).toBe(false);
    });
});

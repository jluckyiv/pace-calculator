import { suite } from 'uvu';
import * as assert from 'uvu/assert';

const sum = suite('sum');

// Different assertions per suite
sum('should be a function', () => {
	assert.type(math.sum, 'function');
});

sum('should compute values', () => {
	assert.is(math.sum(1, 2), 3);
	assert.is(math.sum(-1, -2), -3);
	assert.is(math.sum(-1, 1), 0);
});

sum.run();

// Multiple suites

const div = suite('div');

div('should be a function', () => {
	assert.type(math.div, 'function');
});

div('should compute values', () => {
	assert.is(math.div(1, 2), 0.5);
	assert.is(math.div(-1, -2), 0.5);
	assert.is(math.div(-1, 1), -1);
});

div.run();


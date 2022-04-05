// Package dummy is dummy go code to test workflows on.
package dummy

import "github.com/pkg/errors"

// NewStackedError returns an error with stack.
func NewStackedError(err error) error {
	return errors.WithStack(err)
}

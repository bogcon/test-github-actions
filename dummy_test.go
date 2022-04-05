package dummy_test

import (
	"fmt"
	"io"
	"strings"
	"testing"

	dummy "github.com/bogcon/test-github-actions"
)

func TestNewStackedError(t *testing.T) {
	result := dummy.NewStackedError(io.ErrUnexpectedEOF)

	if result == nil {
		t.Fatal("should not be nil")
	}
	fullMsg := fmt.Sprintf("%+v", result)
	if !strings.Contains(fullMsg, t.Name()) {
		t.Error("doesn't seem to have stack")
	}
}

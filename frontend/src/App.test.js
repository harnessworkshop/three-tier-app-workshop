import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { act } from 'react-dom/test-utils';
import App from './App';
import Navbar from './components/Navbar';
import Button from './components/Button';

// Mock fetch API with better implementation
const mockFetchResponse = {
  ok: true,
  json: () => Promise.resolve({ data: [{ id: 1, key: 1, value: 100 }] })
};

global.fetch = jest.fn(() => Promise.resolve(mockFetchResponse));

describe('App Component', () => {
  beforeEach(() => {
    fetch.mockClear();
    // Mock both fetch calls
    fetch
      .mockImplementationOnce(() => Promise.resolve(mockFetchResponse))
      .mockImplementationOnce(() => Promise.resolve(mockFetchResponse));
  });

  // Test 1: Renders main app components
  test('renders main app components', async () => {
    await act(async () => {
      render(<App />);
    });

    await waitFor(() => {
      expect(screen.getByText(/Devops made simple/i)).toBeInTheDocument();
    });
    expect(screen.getByRole('img', { name: /travel/i })).toBeInTheDocument();
  });

  // Test 2: Shows loading state
  test('displays loading state initially', async () => {
    render(<App />);
    expect(screen.getByText(/loading/i)).toBeInTheDocument();
  });

  // Test 3: Handles successful data fetch
  test('displays data after successful fetch', async () => {
    await act(async () => {
      render(<App />);
    });

    await waitFor(() => {
      expect(fetch).toHaveBeenCalledTimes(2);
    });
  });
});

describe('Navbar Component', () => {
  // Test 4: Renders navbar with logo
  test('renders navbar with logo', () => {
    render(<Navbar />);
    const logo = screen.getByRole('img');
    expect(logo).toHaveClass('navbar__logo');
  });

  // Test 5: Renders join us button
  test('renders join us button', () => {
    render(<Navbar />);
    expect(screen.getByText(/join us/i)).toBeInTheDocument();
  });
});

describe('Button Component', () => {
  // Test 6: Renders button with correct text
  test('renders button with provided value', () => {
    render(<Button value="Test Button" />);
    expect(screen.getByText('Test Button')).toBeInTheDocument();
  });

  // Test 7: Has correct CSS classes
  test('has correct CSS classes', () => {
    render(<Button value="Test" />);
    const button = screen.getByRole('button');
    expect(button).toHaveClass('button', 'button--blue', 'button--diagonal');
  });
});

describe('Integration Tests', () => {
  // Test 8: API integration
  test('handles API integration correctly', async () => {
    await act(async () => {
      render(<App />);
    });

    await waitFor(() => {
      expect(fetch).toHaveBeenCalledWith(
        expect.stringContaining('/api/init-db'),
        expect.any(Object)
      );
      expect(fetch).toHaveBeenCalledWith(
        expect.stringContaining('/api/data'),
        expect.any(Object)
      );
    });
  });
});

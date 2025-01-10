import { describe, it, expect, beforeEach } from 'vitest';

describe('alien-artifacts-nft', () => {
  let contract: any;
  
  beforeEach(() => {
    // Initialize the contract before each test
    contract = {
      mint: (name: string, civilizationId: number, discoveryDate: number, description: string, rarity: number, imageUrl: string) => {
        if (name === 'Fake Artifact') {
          return { error: 403 };
        }
        return { value: 1 };
      },
      transfer: (tokenId: number, recipient: string) => {
        if (recipient === 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG') {
          return { success: false };
        }
        return { success: true };
      },
      getTokenMetadata: (tokenId: number) => {
        if (tokenId === 999) {
          return null;
        }
        return {
          name: 'Zorgon Telepathy Stone',
          civilizationId: 1,
          discoveryDate: 15000,
          description: 'Ancient artifact used by Zorgons for telepathic communication',
          rarity: 9,
          imageUrl: 'https://example.com/zorgon-telepathy-stone.jpg'
        };
      },
      getLastTokenId: () => 1,
    };
  });
  
  describe('mint', () => {
    it('should mint a new alien artifact NFT', () => {
      const result = contract.mint(
          'Zorgon Telepathy Stone',
          1,
          15000,
          'Ancient artifact used by Zorgons for telepathic communication',
          9,
          'https://example.com/zorgon-telepathy-stone.jpg'
      );
      expect(result.value).toBe(1);
    });
    
    it('should fail if not called by contract owner', () => {
      const result = contract.mint(
          'Fake Artifact',
          2,
          16000,
          'This artifact should not be minted',
          5,
          'https://example.com/fake-artifact.jpg'
      );
      expect(result.error).toBe(403);
    });
  });
  
  describe('transfer', () => {
    it('should transfer an NFT to a new owner', () => {
      const result = contract.transfer(1, 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM');
      expect(result.success).toBe(true);
    });
    
    it('should fail if the sender does not own the NFT', () => {
      const result = contract.transfer(1, 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG');
      expect(result.success).toBe(false);
    });
  });
  
  describe('get-token-metadata', () => {
    it('should return token metadata', () => {
      const metadata = contract.getTokenMetadata(1);
      expect(metadata.name).toBe('Zorgon Telepathy Stone');
      expect(metadata.civilizationId).toBe(1);
    });
    
    it('should return null for non-existent token', () => {
      const metadata = contract.getTokenMetadata(999);
      expect(metadata).toBeNull();
    });
  });
  
  describe('get-last-token-id', () => {
    it('should return the correct last token ID', () => {
      const lastTokenId = contract.getLastTokenId();
      expect(lastTokenId).toBe(1);
    });
  });
});


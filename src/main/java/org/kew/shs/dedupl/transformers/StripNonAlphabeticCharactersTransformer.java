package org.kew.shs.dedupl.transformers;

/**
 * This transformer strips non alphabetic characters
 * @author nn00kg
 *
 */
public class StripNonAlphabeticCharactersTransformer implements Transformer{

	public String transform(String s) {
		return s.replaceAll("[^A-Za-z]", "");
	}
	
}

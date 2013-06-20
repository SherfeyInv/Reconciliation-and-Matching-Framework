package org.kew.shs.dedupl.transformers;

import org.apache.commons.lang.StringUtils;

/**
 * This transformer translates zeros to blanks
 * @author nn00kg
 *
 */
public class ZeroToBlankTransformer implements Transformer{

	public String transform(String s) {
		String transformed = s;
		if (StringUtils.isNotBlank(s) & s.equals("0"))
			transformed = "";
		return transformed;
	}
	
}
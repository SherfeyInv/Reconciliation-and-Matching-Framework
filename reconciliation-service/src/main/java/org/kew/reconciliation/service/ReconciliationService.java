package org.kew.reconciliation.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;

import org.kew.reconciliation.queryextractor.QueryStringToPropertiesExtractor;
import org.kew.reconciliation.refine.domain.metadata.Metadata;
import org.kew.stringmod.dedupl.configuration.MatchConfiguration;
import org.kew.stringmod.dedupl.configuration.ReconciliationServiceConfiguration;
import org.kew.stringmod.dedupl.exception.MatchExecutionException;
import org.kew.stringmod.dedupl.exception.TooManyMatchesException;
import org.kew.stringmod.dedupl.lucene.LuceneMatcher;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.support.GenericXmlApplicationContext;
import org.springframework.stereotype.Service;

/**
 * The ReconciliationService handles loading and using multiple reconciliation configurations.
 */
@Service
public class ReconciliationService {
	private static Logger logger = LoggerFactory.getLogger(ReconciliationService.class);

	@Value("#{'${configurations}'.split(',')}")
	private List<String> configurations;

	private final String CONFIG_BASE = "/META-INF/spring/reconciliation-service/";
	private final String CONFIG_EXTENSION = ".xml";

	private Map<String, LuceneMatcher> matchers = new HashMap<String, LuceneMatcher>();
	private Map<String, Integer> totals = new HashMap<String, Integer>();

	private boolean initialised = false;

	/**
	 * Loads the configured match configurations.
	 */
	@PostConstruct
	public void init() {
		logger.debug("Initialising reconciliation service");
		if (!initialised) {
			// Load up the matchers from the specified files
			if (configurations != null) {
				for (String config : configurations) {
					String configurationFile = CONFIG_BASE + config + CONFIG_EXTENSION;
					logger.debug("Processing configuration {} from {}", config, configurationFile);

					@SuppressWarnings("resource")
					ConfigurableApplicationContext context = new GenericXmlApplicationContext(configurationFile);
					context.registerShutdownHook();
					LuceneMatcher matcher = context.getBean("engine", LuceneMatcher.class);
					try {
						matcher.loadData(); 
						logger.debug("Loaded data for configuration {}", config);
						String configName = matcher.getConfig().getName(); 
						matchers.put(configName, matcher);
						totals.put(configName, matcher.getIndexReader().numDocs());
						logger.debug("Stored matcher from config {} with name {}", config, configName);

						// Append " (environment)" to Metadata name, to help with interactive testing
						Metadata metadata = getMetadata(configName);
						if (metadata != null) {
							String env = System.getProperty("environment", "unknown");
							if (!"prod".equals(env)) {
								metadata.setName(metadata.getName() + " (" + env + ")");
							}
						}
					}
					catch (Exception e) {
						logger.error("Problem initialising handler from configuration " + config, e);
					}
				}
			}
			initialised = true;
		}
		else {
			logger.warn("Reconciliation service was already initialised");
		}
	}

	/**
	 * Retrieve reconciliation service metadata.
	 * @throws MatchExecutionException if the requested matcher doesn't exist.
	 */
	public Metadata getMetadata(String configName) throws MatchExecutionException {
		ReconciliationServiceConfiguration reconcilationConfig = getReconciliationServiceConfiguration(configName);
		if (reconcilationConfig != null) {
			Metadata metadata = reconcilationConfig.getReconciliationServiceMetadata();
			if (metadata.getDefaultTypes() == null || metadata.getDefaultTypes().length == 0) {
				throw new MatchExecutionException("No default type specified, Open Refine 2.6 would fail");
			}
			return metadata;
		}
		return null;
	}

	/**
	 * Convert single query string into query properties.
	 * @throws MatchExecutionException if the requested matcher doesn't exist.
	 */
	public QueryStringToPropertiesExtractor getPropertiesExtractor(String configName) throws MatchExecutionException {
		ReconciliationServiceConfiguration reconcilationConfig = getReconciliationServiceConfiguration(configName);
		if (reconcilationConfig != null) {
			return reconcilationConfig.getQueryStringToPropertiesExtractor();
		}
		return null;
	}

	/**
	 * Perform match query against specified configuration.
	 * @throws MatchExecutionException 
	 * @throws TooManyMatchesException 
	 */
	public synchronized List<Map<String,String>> doQuery(String configName, Map<String, String> userSuppliedRecord) throws TooManyMatchesException, MatchExecutionException {
		List<Map<String,String>> matches = null;

		LuceneMatcher matcher = getMatcher(configName);

		if (matcher == null) {
			// When no matcher specified with that configuration
			logger.warn("Invalid match configuration «{}» requested", configName);
			return null;
		}

		matches = matcher.getMatches(userSuppliedRecord, 5);
		// Just write out some matches to std out:
		logger.debug("Found some matches: {}", matches.size());
		if (matches.size() < 4) {
			logger.debug("Matches for {} are {}", userSuppliedRecord, matches);
		}

		return matches;
	}

	/**
	 * Retrieve reconciliation service configuration.
	 * @throws MatchExecutionException if the requested configuration doesn't exist.
	 */
	public ReconciliationServiceConfiguration getReconciliationServiceConfiguration(String configName) throws MatchExecutionException {
		MatchConfiguration matchConfig = getMatcher(configName).getConfig();
		if (matchConfig instanceof ReconciliationServiceConfiguration) {
			ReconciliationServiceConfiguration reconcilationConfig = (ReconciliationServiceConfiguration) matchConfig;
			return reconcilationConfig;
		}
		return null;
	}

	/* • Getters and setters • */
	public Map<String, LuceneMatcher> getMatchers() {
		return matchers;
	}
	public LuceneMatcher getMatcher(String matcher) throws MatchExecutionException {
		if (matchers.get(matcher) == null) {
			throw new MatchExecutionException("No matcher called '"+matcher+"' exists.");
		}
		return matchers.get(matcher);
	}

	public List<String> getConfigFiles() {
		return configurations;
	}
	public void setConfigFiles(List<String> configFiles) {
		this.configurations = configFiles;
	}
}